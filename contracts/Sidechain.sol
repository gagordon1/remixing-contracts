import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';


/**
 * Implements the ISidechain interface
 */
 contract Sidechain{


 	/**
 	 * Given a parent address and the REP for the work, create the contract
 	 */
	constructor(address parent, uint256 REP){
		//TODO
	}

	function getRemixMap() private view returns(mapping(address => uint256)){
		//TODO
	}



	function getParent() public view returns (address){
		//TODO
	}


	function getREP() public view returns (uint256) {
		//TODO
	}
	
}