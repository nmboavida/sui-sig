import { generateSuiEd25519KeyPairAndAddress } from "../ts/utils";

const { keyPair, address } = generateSuiEd25519KeyPairAndAddress();

console.log(`Pubkey Key Bytes: `, keyPair.publicKey);
console.log(`Private Key Bytes (extended): `, keyPair.secretKey);
console.log(`Private Key Bytes (short): `, keyPair.secretKey.slice(0, 32));
console.log(`Sui Address: ${address}`);
