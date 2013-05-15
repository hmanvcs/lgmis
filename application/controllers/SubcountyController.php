<?php

class SubcountyController extends SecureController {
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return isLGMISAdmin() ? "Location Details" : "Subcounty"; 
	}
}