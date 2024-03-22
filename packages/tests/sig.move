#[test_only]
module suisig::sig_test {
    use sui::object::{Self, ID};
    use suisig::sig;
    use suisig::test_vars::{
        wallet_a1, pubkey_1, wallet_b1, sig_1,
        wallet_a2, pubkey_2, wallet_b2, sig_2,
        wallet_a3, pubkey_3, wallet_b3, sig_3,
    };

    fun create_msg_and_sign(
        affected_address: address,
        new_address: address,
        pool_id: ID,
    ): vector<u8> {
        sig::construct_msg(
            sig::address_to_bytes(affected_address),
            sig::address_to_bytes(new_address),
            pool_id,
        )
    }

    #[test]
    fun test_create_msg_and_sign() {
        let msg = create_msg_and_sign(
            wallet_a1(),
            wallet_b1(),
            object::id_from_address(@0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
        );

        // Sanity check
        assert!(sui::ed25519::ed25519_verify(&sig_1(), &pubkey_1(), &msg),0);
        
        let msg = create_msg_and_sign(
            wallet_a2(),
            wallet_b2(),
            object::id_from_address(@0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
        );

        // Sanity check
        assert!(sui::ed25519::ed25519_verify(&sig_2(), &pubkey_2(), &msg),0);
        
        let msg = create_msg_and_sign(
            wallet_a3(),
            wallet_b3(),
            object::id_from_address(@0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
        );

        // Sanity check
        assert!(sui::ed25519::ed25519_verify(&sig_3(), &pubkey_3(), &msg),0);
    }

    #[test]
    fun test_public_key_to_sui_address() {
        let addr = sig::public_key_to_sui_address(pubkey_1());
        assert!(addr == wallet_a1(), 0);
        let addr = sig::public_key_to_sui_address(pubkey_2());
        assert!(addr == wallet_a2(), 0);
        let addr = sig::public_key_to_sui_address(pubkey_3());
        assert!(addr == wallet_a3(), 0);
    }
}

