<?php

class CountyController extends SecureController {
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return isLGMISAdmin() ? "Location Details" : "District"; 
	}
}