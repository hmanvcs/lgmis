<?php

class PricesourceController extends SecureController  {
	/**
	 * @see SecureController::getResourceForACL()
	 *
	 * @return String
	 */
	function getResourceForACL() {
		return "Price Source"; 
	}
}