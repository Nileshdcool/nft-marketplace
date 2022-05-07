// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    constructor() {
         _registerInterface(bytes4(keccak256('totalSupply(bytes4)')) ^
        bytes4(keccak256('tokenByIndex(bytes4)')) ^ bytes4(keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    // 1 => 1 | 2=>2
    mapping(uint256 => uint256) private _allTokensIndex;
    
    // mapping of owner to list of all owner token ids
    // #232324 => [1,5,6]
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID index of the owner tokens list
    // 1 => 
    mapping(uint256 => uint256) private _ownedTokensIndex;

    function _mint(address to, uint256 tokenId) internal override(ERC721)
    {
        super._mint(to,tokenId);
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to,tokenId);
    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    } 

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private
    {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function tokenByIndex(uint256 index) public view override returns(uint256) {
        // index should not be out of bounds
        require(index < totalSupply(),'global index is out of bounds');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public view override returns(uint256) {
        require(index < balanceOf(owner),'global index is out of bounds');
        return _ownedTokens[owner][index];
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
}