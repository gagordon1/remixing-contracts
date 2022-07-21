
/**
 * A compliant Sidechain token provides the wallet address and REP for each
 * prior derivative
 */
interface ISidechain{

	/**
	 * Returns mapping showing contract owner address => REP (will be recursive)
	 * For use in constructor of a contract, allocating shares of the work
	 */
	function getRemixMap() internal view returns(mapping(address => uint256));


	/**
	 * Gets the address of this contract's parent
	 */
	function getParent() external view returns (address);

	
	/**
	 * Gets the REP of the contract
	 */
	function getREP() external view returns (uint256);
	
}