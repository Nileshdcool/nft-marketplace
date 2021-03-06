// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './ERC165.sol';
import './interfaces/IERC721.sol';

/*
a. nft to point to an address
b. keep track of the token ids
c. keep track of token owner address to token ids
d. keep track of how many tokens an owner address has
e. create an event that emits a trafer log > wjher eos os being minted tp, the id etc
*/

contract ERC721 is ERC165, IERC721 {

    // mapping from token id to the owner

    mapping(uint => address) private _tokenOwner;

    // mapping from owner to number of ownerd tokens
    mapping (address => uint) private _ownedTokensCount;


    //mapping from toneid to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')) ^
        bytes4(keccak256('ownerOf(bytes4)')) ^ 
        bytes4(keccak256('transferFrom(bytes4)')));
    }
     

    function balanceOf(address _owner) public view override returns(uint256)
    {
        require(_owner != address(0), 'ERC721: owner query non-existent token');
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address)
    {
        address owner = _tokenOwner[_tokenId];
         require(owner != address(0), 'ERC721: owner query non-existent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
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

    /// @notice Transfer ownership of an NFT
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal  {
        require(_to != address(0),'Error - ERC721 trafer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token a address does not exist');
        _ownedTokensCount[_from] -=1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);

    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        require(isApprovedOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "Error - approval to current owner");
        require(msg.sender == owner , "Current owner is not the owner of the token");
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOwner(address _spender, uint256 _tokenId) internal view returns(bool) {
        require(_exists(_tokenId),'token does not exists');
        address owner = ownerOf(_tokenId);
        return (_spender == owner);
    }
}