module MyModule::NFTGifting {
    use aptos_framework::signer;
    use std::string::String;

    /// Struct representing an NFT gift
    struct NFTGift has key {
        token_id: u64,             // Unique identifier for the NFT
        name: String,              // Name/title of the NFT
        description: String,       // Description of the NFT
        original_owner: address,   // Address of the creator/gifter
        current_owner: address,    // Current owner of the NFT
        is_gifted: bool,           // Whether this NFT was gifted
    }

    /// Function to create and mint a new NFT gift
    public entry fun create_nft_gift(
        creator: &signer, 
        token_id: u64, 
        name: String, 
        description: String
    ) {
        let creator_address = signer::address_of(creator);

        let nft_gift = NFTGift {
            token_id,
            name,
            description,
            original_owner: creator_address,
            current_owner: creator_address,
            is_gifted: false,
        };

        move_to<NFTGift>(creator, nft_gift);
    }

    /// Function to gift an NFT to another user
    public entry fun gift_nft(
        gifter: &signer, 
        recipient: &signer, 
        token_id: u64
    ) acquires NFTGift {
        let gifter_address = signer::address_of(gifter);

        // Move the NFT out of the gifter's account
        let nft_gift = move_from<NFTGift>(gifter_address);

        // Validate that this is the correct NFT being gifted
        assert!(nft_gift.token_id == token_id, 100);

        // Update ownership details
        nft_gift.current_owner = signer::address_of(recipient);
        nft_gift.is_gifted = true;

        // Transfer NFT to recipient
        move_to<NFTGift>(recipient, nft_gift);
    }
}
