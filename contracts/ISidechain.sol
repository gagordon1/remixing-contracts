
/**
 * A compliant Sidechain token provides the wallet address and REP for each
 * prior derivative
 */
interface ISidechain{

	/**
	 * Returns mapping showing contract owner address -> REP (will be recursive)
	 */
	function getRemixMap();


	/**
	 * Gets the address of this contract's parent
	 */
	function getParent();

	
	/**
	 * Gets the REP of the contract
	 */
	function getREP();
	
}