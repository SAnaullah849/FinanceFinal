Educational project for the course Introduction to Finance. Not a real product, service or investment offer. Do not use with real funds.

# WattTrail EU

An educational renewable-energy certificate registry. Fictional companies and plants; no official certificates, payments, cryptocurrency, or public-chain deployment.

## Two web modes

1. **Local blockchain (assignment demo):** `npm start` compiles and deploys Solidity to an in-memory Ganache EVM chain, registers four plants, seeds one certificate, and serves the web interface. Transactions are executed on that local chain. No wallet extension is required.
2. **Static web preview:** `npm run build` produces `dist/`. On static hosting the interface explicitly switches to a browser-storage simulation. It does **not** demonstrate blockchain execution and cannot substitute for the local demo.

## Requirements and setup

Node.js 22 or 24 LTS, npm, and a browser. Extract this folder, open a terminal in it, then:

```bash
npm ci
npm run compile
npm test
npm start
```

Open **http://localhost:3000**. Keep the terminal running. Stop with Ctrl+C. Restarting resets the in-memory chain. Ganache is the local development blockchain used instead of the assignment's example tools Hardhat/Anvil.

The deployment terminal prints the contract address, chain ID and transaction confirmations; it deliberately does not print private keys. The web account selector switches among three unlocked **local test accounts** to demonstrate issuer and owner roles. The backend is loopback-only, validates Host and Origin, and must never be exposed or deployed as a public signing service.

## Demonstration steps

1. Start the server; show `LOCAL DEPLOYMENT COMPLETE`, contract address and chain ID 1337.
2. Open Hourly issuance as Elmsworth Renewables / Issuer. The default hour is two hours before now (UTC). Issue 24 MWh from Elmsworth Wind Park. A seed batch exists for the previous hour; do not duplicate that hour.
3. Open Certificates and View the new record. Transfer it to Alpenforge Industries.
4. Change the acting account to Alpenforge Industries / Buyer. Reopen the record, enter a fictional beneficiary and claim purpose, and retire.
5. Verify `WT-EU-2`. Inspect the event trail, transaction hashes and block numbers.
6. Run `npm test` in a second terminal to show passing unit tests. Tests use their own independent local chain.
7. Optional: show Financials and compare base adoption, 75% adoption, and operating costs +20%.

## Contract and tests

`contracts/CertificateRegistry.sol` exposes `registerPlant`, `issueCertificates`, `transferCertificate`, `retireCertificate`, and `getCertificate`.

Issuer: fixed deployer; plant registration and issuance only. Owners: transfer and retirement of their own batches only. Read access is open on the local network. Whole MWh are grouped in hourly batches. Each plant-hour can be issued once. This simplified model intentionally disallows splitting batches and incremental issuance. Issuer data accuracy is assumed; hourly capacity bounds do not prove meter accuracy.

The 12 automated tests cover registration, issuer permissions, valid issuance, duplicate hours, capacity bounds, unknown plants, timestamp validation, zero owner, owner permissions, transfer event history, former-owner denial, retirement, and post-retirement restrictions. All tests compile and execute Solidity against Ganache; they do not mock contract logic.

## Security and architecture

Browser → loopback Node HTTP server → ethers → in-process Ganache EVM → Solidity contract. The server compiles using pinned solc. Events provide the local custody history; no external blockchain, Fabric network, oracle or official registry is connected.

- Broken access control: contract checks fixed issuer and current owner on mutations.
- Double counting: unique plant-hour key and irreversible retired state.
- Key exposure: no private keys or seed phrases are stored in source or printed; local-only unlocked accounts have no real assets.
- Reentrancy: contract performs no external calls or value transfers.
- Real production needs trusted metering, identity management, legal review, key management and independent auditing. The development EVM is not a production consensus design. Explain the distinction from any proposed permissioned/Fabric architecture in your report.

## Financial assumptions

EUR assumptions are fictional, not a currency conversion or market forecast. Annual producer subscriptions €6k; buyers €12k; registry fee €0.20/MWh. Producer count 8/20/35; buyer count 6/15/30; volume 300k/800k/1.5m MWh; services €30k/€60k/€100k. Revenue €210k/€520k/€970k and base costs €330k/€430k/€550k. Initial spending €325k. Default venture discount 25% (adjustable 20–30%). Three-year NPV excludes terminal value. Payback uses annual cash flows with linear interpolation. Minimum funding equals the largest negative cumulative project cash balance, without contingency. Two pessimistic scenarios are lower adoption and costs +20%. The model is simplified and excludes taxes, depreciation, debt, working capital and funding dilution. Students must review, justify and own their calculations.

## GitHub upload

Create a repository, then upload **this folder's contents**, including package-lock.json. Do not upload node_modules, .env, generated artifacts or dist. Each teammate must contribute their own genuine commits from their own GitHub account; do not fabricate contributions. Give the instructor access if private.

```bash
git init
git add .
git commit -m "Add educational WattTrail prototype"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

## Optional static hosting

Vercel config is provided: build command `npm run build`, output `dist`. This publishes the **browser simulation only**. The assignment prohibits launching a real product or public advertising; keep this as an educational, restricted demonstration and follow instructor requirements. Local chain mode is what you record for grading.

## Submission links — complete before submitting

- GitHub repository: ADD YOUR ACTUAL REPOSITORY URL
- Demo video (maximum 3 minutes, link-accessible): ADD YOUR ACTUAL VIDEO URL
- Team/group details: ADD YOUR VERIFIED DETAILS

Put repository and video links on the report title page and presentation title slide. Put the repository link in Moodle. Include a sequence diagram, security analysis, and financial discussion in the report; this repository is only the coding deliverable.

## Team and AI disclosure

Team: Sanaullah Gulzar, Baygali Zhumabay, Kamila Ahmadzada (verify spelling before submission). Assign and document real roles and contributions yourselves.

This starter was generated with ChatGPT using an OpenAI coding model. The exact model identifier was not supplied to this runtime; record the exact model shown in your ChatGPT interface before submitting the AI disclosure. AI assisted contract, frontend, local server, tests and documentation. All members must review and explain every part. This is a starter for student verification, not a claim of independent student authorship.

## Dependencies and credits

ethers 6.15.0 (MIT), Ganache 7.9.2 (MIT), Solidity compiler solc 0.8.30 (GPL-3.0). Refer to installed package license files and upstream license terms. No OpenZeppelin code is included. Application source is MIT licensed; see LICENSE.
