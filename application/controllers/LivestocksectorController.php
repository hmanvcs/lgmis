<?php

class LivestocksectorController extends SecureController {	
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return "Livestock Production"; 
	}
	public function livestockinfoAction(){
		
	}
	public function livestockinfolistAction(){
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
	function livestockinfolistsearchAction(){
		$this->_helper->redirector->gotoSimple('livestockinfolist', $this->getRequest()->getControllerName(), 
    											$this->getRequest()->getModuleName(),
    											array_remove_empty(array_merge_maintain_keys($this->_getAllParams(), $this->getRequest()->getQuery())));
	}
	
	/* (non-PHPdoc)
	 * @see SecureController::getActionforACL()
	 */
	public function getActionforACL() {
		$action = strtolower($this->getRequest()->getActionName()); 
		
		if ($action == 'livestockinfo') {
			return ACTION_CREATE; 
		}
		if ($action == 'processlivestockinfo') {
			return ACTION_CREATE; 
		}
		if ($action == 'livestockinfolist' || $action == 'livestockinfolistsearch') {
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
		
	    // add the parameters for updating the visit
		$this->_setParam('entityname', 'LivestockProduction'); 
		$this->_setParam('action', ACTION_CREATE);
		$submission_data = array();
		$counter = $formvalues['counter'];
		for($i=0; $i<$counter; $i++){
			if(!isArrayKeyAnEmptyString('commodityid_'.$i, $formvalues)){
				$submission_data[$i]['commodityid'] = $formvalues['commodityid_'.$i];	
				$submission_data[$i]['cost'] = $formvalues['cost_'.$i];
				$submission_data[$i]['yield'] = $formvalues['yield_'.$i];
				$submission_data[$i]['seedsource'] = $formvalues['seedsource_'.$i];
				
				if(!isArrayKeyAnEmptyString('customunittrigger_'.$i, $formvalues)){
					if($formvalues['customunittrigger_'.$i] == 1){
						$submission_data[$i]['unit'] = NULL;
						$submission_data[$i]['customunit'] = $formvalues['customunit_'.$i];
					}
				} else {
					$submission_data[$i]['unitid'] = $formvalues['unitid_'.$i];
					$submission_data[$i]['customunit'] = "";
				}
				if(!isArrayKeyAnEmptyString('customprodtypetrigger_'.$i, $formvalues)){
					if($formvalues['customprodtypetrigger_'.$i] == 1){
						$submission_data[$i]['prodtype'] = NULL;
						$submission_data[$i]['customprodtype'] = $formvalues['customprodtype_'.$i];
					}
				} else {
					// $submission_data[$i]['prodtype'] = $formvalues['prodtype_'.$i];
					$submission_data[$i]['customprodtype'] = $formvalues['prodtype_'.$i];
				}
				/*if(!isArrayKeyAnEmptyString('customyieldtypetrigger_'.$i, $formvalues)){
					if($formvalues['customyieldtypetrigger_'.$i] == 1){
						$submission_data[$i]['yieldtype'] = NULL;
						$submission_data[$i]['customyieldtype'] = $formvalues['customyieldtype_'.$i];
					}
				} else {
					$submission_data[$i]['yieldtype'] = $formvalues['yieldtype_'.$i];
					$submission_data[$i]['customyieldtype'] = "";
				}*/
				
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
		
		debugMessage($submission_data); //exit();
		// collection to be used to save submissions
		$livestocksector_collection = new Doctrine_Collection("LivestockProduction");
		
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			$livestocksector = new LivestockProduction();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$livestocksector->processPost($thedata);
				//debugMessage($livestocksector->getErrorStackAsString());
				//debugMessage($livestocksector->toArray());
				
				if($livestocksector->isValid()) {
					$livestocksector_collection->add($livestocksector);
				}
			} else {
				$livestocksector->populate($thedata['id']);
				$livestocksector->synchronizeWithArray($thedata, true);
				$livestocksector_collection->add($livestocksector);
			}
		}
		// exit();
		try {
			// save the collection of crop sectors
			$livestocksector_collection->save(); 
			// through commodity price category and add ti 
			foreach ($livestocksector_collection as $sector) {
				$cpc = new CommodityPriceCategory();
				$cpc_obj = $cpc->getTheCommodityPriceCategory($sector->getCommodityID(), 8);
				// debugMessage($cpc_obj->toArray());
				if(!$cpc_obj){
					// category for commodity not found. save new
					$cpc->setCommodityID($sector->getCommodityID());
					$cpc->setPriceCategoryID(8);
					$cpc->save();
				}
			}
			// redirect to success page
			$this->_redirect($this->view->baseUrl('livestocksector/list/quarter/'.$this->_getParam('quarter')));
			
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			
			$this->_redirect($this->view->baseUrl('livestocksector/create/quarter/'.$this->_getParam('quarter')));
		}
	}
	/*
	 * process livestock informatoin
	 */
	public function processlivestockinfoAction(){
		$this->_helper->layout->disableLayout();
	    $session = SessionWrapper::getInstance(); 
	    $this->_translate = Zend_Registry::get("translate"); 
	    $this->_setParam('entityname', 'LivestockProduction'); 
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
		for($i=0; $i<$counter; $i++){
			if(!isArrayKeyAnEmptyString('commodityid_'.$i, $formvalues)){
				$submission_data[$i]['commodityid'] = $formvalues['commodityid_'.$i];	
				//$submission_data[$i]['breedsource'] = $formvalues['breedsource_'.$i];	
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
		// collection to be used to save submissions
		$livestocksectorinfo_collection = new Doctrine_Collection("LivestockInformation");
		
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			$livestocksectorinfo = new LivestockInformation();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$livestocksectorinfo->processPost($thedata);
				if($livestocksectorinfo->isValid()) {
					$livestocksectorinfo_collection->add($livestocksectorinfo);
				}
			} else {
				$livestocksectorinfo->populate($thedata['id']);
				$livestocksectorinfo->synchronizeWithArray($thedata, true);
				$livestocksectorinfo_collection->add($livestocksectorinfo);
			}
		}

		try {
			// save the collection of crop sectors
			$livestocksectorinfo_collection->save();
			// through commodity price category and add ti 
			foreach ($livestocksectorinfo_collection as $sector) {
				$cpc = new CommodityPriceCategory();
				$cpc_obj = $cpc->getTheCommodityPriceCategory($sector->getCommodityID(), 8);
				// debugMessage($cpc_obj->toArray());
				if(!$cpc_obj){
					// category for commodity not found. save new
					$cpc->setCommodityID($sector->getCommodityID());
					$cpc->setPriceCategoryID(8);
					$cpc->save();
				}
			}
			
			// redirect to success page
			$this->_redirect($this->view->baseUrl('livestocksector/livestockinfolist/quarter/'.$this->_getParam('quarter')));
			
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			
			$this->_redirect($this->view->baseUrl('livestocksector/livestockinfo/quarter/'.$this->_getParam('quarter')));
		}
	}
}

