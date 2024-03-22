import * as nacl from "tweetnacl";
import {
  byteArrayToHexString,
  generateSuiEd25519KeyPairAndAddress,
  hexStringToByteArray,
  publicKeyToSuiAddress,
} from "../ts/utils";

function constructMsg(
  affectedPubkeyBytes: Uint8Array,
  newPubkeyBytes: Uint8Array,
  poolIdBytes: Uint8Array // Assuming poolId is a string that needs to be converted to bytes
): Uint8Array {
  const affectedAddressBytes = hexStringToByteArray(
    publicKeyToSuiAddress(affectedPubkeyBytes)
  );

  const newAddressBytes = hexStringToByteArray(
    publicKeyToSuiAddress(newPubkeyBytes)
  );

  // Construct the message by concatenating the byte arrays
  const msg = new Uint8Array(
    affectedAddressBytes.length + newAddressBytes.length + poolIdBytes.length
  );
  msg.set(affectedAddressBytes, 0);
  msg.set(newAddressBytes, affectedAddressBytes.length);
  msg.set(poolIdBytes, affectedAddressBytes.length + newAddressBytes.length);

  return msg;
}

const poolId =
  "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

const keypairA = generateSuiEd25519KeyPairAndAddress();
const keypairB = generateSuiEd25519KeyPairAndAddress();

const msg = constructMsg(
  keypairA.keyPair.publicKey,
  keypairB.keyPair.publicKey,
  hexStringToByteArray(poolId)
);

const signedMsg = nacl.sign(msg, keypairA.keyPair.secretKey);
const signatureBytes = signedMsg.slice(0, 64);

console.log("WALLET A: ", keypairA.address);
console.log("WALLET A (PUBKEY): ", keypairA.keyPair.publicKey);
console.log("WALLET B: ", keypairB.address);

console.log("Message:", byteArrayToHexString(msg));
console.log("Signature HEX:", byteArrayToHexString(signatureBytes));
