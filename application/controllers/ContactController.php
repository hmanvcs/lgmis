<?php

class ContactController extends SecureController {
	
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		if(isApplicationLGMIS()){
			return isLGMISAdmin() || isLGMISOfficial() ? "Location Statistic" : "Contact"; 
		}
		parent::getResourceForACL();
	}
	public function getActionforACL() {
		$action = strtolower($this->getRequest()->getActionName()); 
		
		if(isApplicationLGMIS()){
			return ACTION_VIEW; 
		}
		return parent::getActionforACL(); 
	}
}