// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
/// @notice Educational, local-network registry. No currency or investment token.
contract CertificateRegistry {
    address public immutable issuer;
    uint256 public nextId = 1;
    struct Plant { string name; string country; uint256 capacity; bool exists; }
    struct Certificate { uint256 plant; uint256 hour; uint256 mwh; address owner; bool retired; string beneficiary; string purpose; }
    mapping(uint256 => Plant) public plants;
    mapping(uint256 => Certificate) private certificates;
    mapping(bytes32 => bool) public issued;
    event PlantRegistered(uint256 indexed plant, string name);
    event Issued(uint256 indexed id, address indexed owner, uint256 mwh);
    event Transferred(uint256 indexed id, address indexed from, address indexed to);
    event Retired(uint256 indexed id, string beneficiary, string purpose);
    constructor() { issuer = msg.sender; }
    modifier onlyIssuer() { require(msg.sender == issuer, "Issuer only"); _; }
    function registerPlant(uint256 id, string calldata name, string calldata country, uint256 capacity) external onlyIssuer {
        require(!plants[id].exists, "Plant exists");
        require(bytes(name).length > 0 && bytes(country).length > 0 && capacity > 0, "Invalid plant");
        plants[id] = Plant(name, country, capacity, true); emit PlantRegistered(id, name);
    }
    function issueCertificates(uint256 plant, uint256 hour, uint256 mwh, address owner) external onlyIssuer returns(uint256 id) {
        require(plants[plant].exists, "Unknown plant");
        require(hour % 3600 == 0 && hour <= block.timestamp, "Invalid hour");
        require(mwh > 0 && mwh <= plants[plant].capacity, "Invalid volume");
        require(owner != address(0), "Zero owner");
        bytes32 key = keccak256(abi.encode(plant, hour)); require(!issued[key], "Hour already issued");
        issued[key] = true; id = nextId++;
        certificates[id] = Certificate(plant, hour, mwh, owner, false, "", ""); emit Issued(id, owner, mwh);
    }
    function getCertificate(uint256 id) public view returns(Certificate memory) {
        require(certificates[id].owner != address(0), "Unknown certificate"); return certificates[id];
    }
    function transferCertificate(uint256 id, address to) external {
        Certificate storage c = certificates[id]; require(c.owner == msg.sender, "Owner only");
        require(!c.retired, "Retired certificate"); require(to != address(0) && to != c.owner, "Invalid recipient");
        address from = c.owner; c.owner = to; emit Transferred(id, from, to);
    }
    function retireCertificate(uint256 id, string calldata beneficiary, string calldata purpose) external {
        Certificate storage c = certificates[id]; require(c.owner == msg.sender, "Owner only");
        require(!c.retired, "Retired certificate");
        require(bytes(beneficiary).length > 0 && bytes(purpose).length > 0, "Claim details required");
        c.retired = true; c.beneficiary = beneficiary; c.purpose = purpose; emit Retired(id, beneficiary, purpose);
    }
}
