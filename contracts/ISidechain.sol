pragma solidity ^0.8.0;
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
	 * Gets the REP of the contract
	 */
	function getREP() external view returns (uint256);

	/**
	 * When money is to be collected on copyright payment,
	 * split incoming funds according to ownership of the contract's tokens.
	 */
	function collectCopyrightPayment() external payable;

}
