// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
a. nft to point to an address
b. keep track of the token ids
c. keep track of token owner address to token ids
d. keep track of how many tokens an owner address has
e. create an event that emits a trafer log > wjher eos os being minted tp, the id etc
*/

contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // mapping from token id to the owner

    mapping(uint => address) private _tokenOwner;

    // mapping from owner to number of ownerd tokens
    mapping (address => uint) private _ownedTokensCount;

     /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero

    function balanceOf(address _owner) public view returns(uint256)
    {
        require(_owner != address(0), 'ERC721: owner query non-existent token');
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address)
    {
        address owner = _tokenOwner[_tokenId];
         require(owner != address(0), 'ERC721: owner query non-existent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal {
        // requires that the address is not zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // require that the token does not exisist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one
        _ownedTokensCount[to] = _ownedTokensCount[to] + 1;

        emit Transfer(address(0), to, tokenId);
    }
}