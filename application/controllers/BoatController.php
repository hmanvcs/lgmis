<?php

class BoatController extends SecureController {
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return "Landing Site"; 
	}
}