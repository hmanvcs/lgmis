<?php

class CropsectorController extends SecureController {	
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return "Crop Production"; 
	}
	
	public function cropsectorinfoAction(){
		
	}
	public function cropsectorinfolistAction(){
		$this->_translate = Zend_Registry::get("translate"); 
		
		$listcount = new LookupType();
    	$listcount->setName("LIST_ITEM_COUNT_OPTIONS");
    	$values = $listcount->getOptionValues(); 
    	asort($values, SORT_NUMERIC); 
    	$dropdown = new Zend_Form_Element_Select('itemcountperpage',
							array(
								'multiOptions' => $values, 
								'view' => new Zend_View(),
								'decorators' => array('ViewHelper')
							)
						);
		if (isEmptyString($this->getRequest()->itemcountperpage)) {
			$dropdown->setValue(10);
		} else {
			$dropdown->setValue($this->getRequest()->itemcountperpage);
		}  
	    $this->view->listcountdropdown = $this->_translate->translate("list_itemcount_dropdown").$dropdown->render();
	}
	function cropsectorinfolistsearchAction(){
		$this->_helper->redirector->gotoSimple('cropsectorinfolist', $this->getRequest()->getControllerName(), 
    											$this->getRequest()->getModuleName(),
    											array_remove_empty(array_merge_maintain_keys($this->_getAllParams(), $this->getRequest()->getQuery())));
	}
	/* (non-PHPdoc)
	 * @see SecureController::getActionforACL()
	 */
	public function getActionforACL() {
		$action = strtolower($this->getRequest()->getActionName()); 
		
		if ($action == 'cropsectorinfo') {
			return ACTION_CREATE; 
		}
		if ($action == 'processcropsectorinfo') {
			return ACTION_CREATE; 
		}
		
		if ($action == 'cropsectorinfolist' || $action == 'cropsectorinfolistsearch' ) {
			return ACTION_LIST; 
		}
		return parent::getActionforACL(); 
	}
	public function createAction(){
		$this->_helper->layout->disableLayout();
	    $session = SessionWrapper::getInstance(); 
	    $this->_translate = Zend_Registry::get("translate"); 
	   
	    $formvalues = $this->_getAllParams();
	    
	    //generate the start and end dates from the quarter
		if(!isArrayKeyAnEmptyString('quarter', $formvalues)){
			$quarter_dates = getDatesForQuarter($formvalues['quarter']); 
			//add the start and end date to formvalues data
			$formvalues = array_merge_maintain_keys($formvalues, $quarter_dates); 
		}
	    // debugMessage($formvalues); exit();
	    
	    // add the parameters for updating the visit
		$this->_setParam('entityname', 'CropProduction'); 
		$this->_setParam('action', ACTION_CREATE);
		$submission_data = array(); 
		$counter = $formvalues['counter'];
		for($i=0; $i <= $counter; $i++){
			if(!isArrayKeyAnEmptyString('commodityid_'.$i, $formvalues)){
				$submission_data[$i]['commodityid'] = $formvalues['commodityid_'.$i];
				$submission_data[$i]['cost'] = $formvalues['cost_'.$i];
				$submission_data[$i]['yield'] = $formvalues['yield_'.$i];
				$submission_data[$i]['unitid'] = $formvalues['unitid_'.$i];
				$submission_data[$i]['prodtype'] = $formvalues['prodtype_'.$i];
				$submission_data[$i]['yieldtype'] = $formvalues['yieldtype_'.$i];
				$submission_data[$i]['seedsource'] = $formvalues['seedsource_'.$i];
				
				$submission_data[$i]['locationid'] = $formvalues['locationid'];
				$submission_data[$i]['collectedbyid'] = $formvalues['collectedbyid'];
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['startdate'] = changeDateFromPageToMySQLFormat($formvalues['startdate']);
				$submission_data[$i]['enddate'] = changeDateFromPageToMySQLFormat($formvalues['enddate']);
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['quarter'] = str_replace(':', '.', $formvalues['quarter']);
				$submission_data[$i]['createdby'] = $session->getVar('userid');
				if(isNotAnEmptyString($formvalues['id_'.$i])){
					$submission_data[$i]['id'] = $formvalues['id_'.$i];
				}
			}
		}
		// debugMessage($submission_data); exit();
		// collection to be used to save submissions
		$cropsector_collection = new Doctrine_Collection("CropProduction");
		
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			$cropsector = new CropProduction();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$cropsector->processPost($thedata);
				//debugMessage($cropsector->getErrorStackAsString());
				//debugMessage($cropsector->toArray());
				if($cropsector->isValid()) {
					$cropsector_collection->add($cropsector);
				}
			} else {
				$cropsector->populate($thedata['id']);
				$cropsector->synchronizeWithArray($thedata, true);
				$cropsector_collection->add($cropsector);
			}
		}
		// debugMessage($cropsector_collection->toArray()); exit();
		
		try {
			// save the collection of crop sectors
			$cropsector_collection->save(); 
			// through commodity price category and add ti 
			foreach ($cropsector_collection as $cropsector) {
				$cpc = new CommodityPriceCategory();
				$cpc_obj = $cpc->getTheCommodityPriceCategory($cropsector->getCommodityID(), 7);
				// debugMessage($cpc_obj->toArray());
				if(!$cpc_obj){
					// category for commodity not found. save new
					$cpc->setCommodityID($cropsector->getCommodityID());
					$cpc->setPriceCategoryID(7);
					$cpc->save();
				}
			}
			// exit();
			// redirect to success page
			$this->_redirect($this->view->baseUrl('cropsector/list/quarter/'.$this->_getParam('quarter')));
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			
			$this->_redirect($this->view->baseUrl('cropsector/create/quarter'.$this->_getParam('quarter')));
		}
	}
	
	/*
	 * Processing for cropsector information
	 */
	public function processcropsectorinfoAction(){
		$this->_helper->layout->disableLayout();
	    $session = SessionWrapper::getInstance(); 
	    $this->_translate = Zend_Registry::get("translate"); 
	    $this->_setParam('entityname', 'CropSectorInformation'); 
		$this->_setParam('action', ACTION_CREATE);
		
	    $formvalues = $this->_getAllParams();
	    
	    //generate the start and end dates from the quarter
		if(!isArrayKeyAnEmptyString('quarter', $formvalues)){
			$quarter_dates = getDatesForQuarter($formvalues['quarter']); 
			//add the start and end date to formvalues data
			$formvalues = array_merge_maintain_keys($formvalues, $quarter_dates); 
		}
	    // debugMessage($formvalues); exit();
	    
	    // add the parameters for updating the crop sector infor
		$submission_data = array();
		$counter = $formvalues['counter'];
		for($i=0; $i <= $counter; $i++){
			if(!isArrayKeyAnEmptyString('commodityid_'.$i, $formvalues)){
				$submission_data[$i]['commodityid'] = $formvalues['commodityid_'.$i];
				//$submission_data[$i]['seedsource'] = $formvalues['seedsource_'.$i];
				$submission_data[$i]['pests'] = $formvalues['pests_'.$i];
				$submission_data[$i]['diseases'] = $formvalues['diseases_'.$i];
				//$submission_data[$i]['creditsource'] = $formvalues['creditsource_'.$i];
				
				$submission_data[$i]['locationid'] = $formvalues['locationid'];
				$submission_data[$i]['collectedbyid'] = $formvalues['collectedbyid'];
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['startdate'] = changeDateFromPageToMySQLFormat($formvalues['startdate']);
				$submission_data[$i]['enddate'] = changeDateFromPageToMySQLFormat($formvalues['enddate']);
				$submission_data[$i]['datecollected'] = changeDateFromPageToMySQLFormat($formvalues['datecollected']);
				$submission_data[$i]['quarter'] = str_replace(':', '.', $formvalues['quarter']);
				$submission_data[$i]['createdby'] = $session->getVar('userid');
				if(isNotAnEmptyString($formvalues['id_'.$i])){
					$submission_data[$i]['id'] = $formvalues['id_'.$i];
				}
			}
		}
		//debugMessage($submission_data); exit();
		// collection to be used to save submissions
		$cropsectorinfo_collection = new Doctrine_Collection("CropSectorInformation");
		
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			$cropsector = new CropSectorInformation();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$cropsector->processPost($thedata);
				//debugMessage($cropsector->getErrorStackAsString());
				//debugMessage($cropsector->toArray());
				if($cropsector->isValid()) {
					$cropsectorinfo_collection->add($cropsector);
				}
			} else {
				$cropsector->populate($thedata['id']);
				$cropsector->synchronizeWithArray($thedata, true);
				$cropsectorinfo_collection->add($cropsector);
			}
		}
		// debugMessage($cropsectorinfo_collection->toArray());
		try {
			// save the collection of crop sectors
			$cropsectorinfo_collection->save(); 
			// through commodity price category and add ti 
			foreach ($cropsectorinfo_collection as $cropsector) {
				$cpc = new CommodityPriceCategory();
				$cpc_obj = $cpc->getTheCommodityPriceCategory($cropsector->getCommodityID(), 7);
				// debugMessage($cpc_obj->toArray());
				if(!$cpc_obj){
					// category for commodity not found. save new
					$cpc->setCommodityID($cropsector->getCommodityID());
					$cpc->setPriceCategoryID(7);
					$cpc->save();
				}
			}
			// redirect to success page
			$this->_redirect($this->view->baseUrl('cropsector/cropsectorinfolist/quarter/'.$this->_getParam('quarter')));
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			
			$this->_redirect($this->view->baseUrl('cropsector/cropsectorinfo/quarter'.$this->_getParam('quarter')));
		}
	}
}

