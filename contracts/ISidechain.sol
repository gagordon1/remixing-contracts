

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol';

// MAX_OWNERSHIP_VALUE = 1 000 equivalent to 100% ownership
//
/**
 * A compliant Sidechain token provides the wallet address and REV for each
 * prior derivative
 */
interface ISidechain is IERC721Enumerable{

	/**
	 * Gets the wallet address of the creator
	 */
	function getCreator() external view returns (address);

	/**
	 * Gets the address of this contract's parent
	 * Returns 0 if the address has no parent.
	 */
	function getParent() external view returns (address);


	/**
	 * Gets the REV of the contract (integer between 0 and MAX_OWNERSHIP_VALUE)
	 */
	function getREV() external view returns (uint16);

	/**
	 * When money is to be collected on copyright payment,
	 * split incoming funds according to ownership of the contract's tokens.
	 */
	function collectCopyrightPayment() external payable;

}