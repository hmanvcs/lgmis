<?php

class CommodityunitController extends SecureController {
	
	/**
	 * @see SecureController::getResourceForACL()
	 *
	 * @return String
	 */
	function getResourceForACL() {
		return isLGMISAdmin() ? "Location Statistic" : "Commodity Unit"; 
	}
}