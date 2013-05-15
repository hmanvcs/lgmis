<?php

class BusinessdirectorycategoryController extends SecureController {
	
	/**
	 * @see SecureController::getResourceForACL()
	 *
	 * @return String
	 */
	function getResourceForACL() {
		return isLGMISAdmin() ? "Location Statistic" : "Business Directory Category"; 
	}
}