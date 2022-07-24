pragma solidity ^0.8.0;

MAX_OWNERSHIP_VALUE = 1 000 000 //equivalent to 100% ownership
/**
 * A compliant Sidechain token provides the wallet address and REP for each
 * prior derivative
 */
interface ISidechain{

	/**
	 * Gets the address of this contract's parent
	 * Returns 0 if the address has no parent.
	 */
	function getParent() external view returns (address);


	/**
	 * Gets the REP of the contract (integer between 0 and MAX_OWNERSHIP_VALUE)
	 */
	function getREP() external view returns (uint256);

	/**
	 * When money is to be collected on copyright payment,
	 * split incoming funds according to ownership of the contract's tokens.
	 */
	function collectCopyrightPayment() external payable;

}
