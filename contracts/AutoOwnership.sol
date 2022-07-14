// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import 'openzeppelin-solidity/contracts/access/Ownable.sol';

contract AutoOwnership is ERC721Enumerable, Ownable {

    using Strings for uint256;

    string _baseTokenURI;
    string _creator;

    // withdraw addresses
    address t1 = 0x468452829705ACE2579Fef3FAE59333Ac33b1CA8; //test account


    constructor(string memory baseURI) ERC721("Auto Ownership", "AUT")  {
        setBaseURI(baseURI);

        setCreator(_creator);

        _safeMint( _creator, 0);
    }

    function getCreator(){
        return _creator;
    }

    function setCreator(address memory _creator){
        _creator = _creator;
    }
}