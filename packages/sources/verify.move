module suisig::verify {
    use sui::ed25519;
    use sui::object::ID;

    use suisig::sig;

    const EIncorrectSignature: u64 = 0;
    const EPubkeyAddressMismatch: u64 = 1;

    public entry fun verify_message(
        address_a: address,
        address_a_pubkey: vector<u8>,
        address_b: address,
        nonce: ID,
        signature: vector<u8>,
    ) {        
        // Assert that pubkey matches address
        assert!(
            sig::public_key_to_sui_address(address_a_pubkey) == address_a,
            EPubkeyAddressMismatch
        );

        let msg = sig::construct_msg(
            sig::address_to_bytes(address_a),
            sig::address_to_bytes(address_b),
            nonce,
        );

        assert!(
            ed25519::ed25519_verify(&signature, &address_a_pubkey, &msg),
            EIncorrectSignature
        );
    }
}