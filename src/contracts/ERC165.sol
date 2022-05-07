// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {
    // write a byte calculation interface function algorithm

    constructor() {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    mapping(bytes4 => bool) private _supportedInterfaces;

    function calcFingerPrint() public pure returns(bytes4) {
        return bytes4(keccak256('supportsInterface(bytes4)'));
    }

    function supportsInterface(bytes4 interfaceID) external override view returns (bool)
    {
        return _supportedInterfaces[interfaceID];
        // supprted interface value : 0: bytes4: 0x01ffc9a7
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, 'ERC165: Invalid interface');
        _supportedInterfaces[interfaceId] = true;
    } 
}