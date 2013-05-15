<?php

class LgmisController extends IndexController {
	
	function preDispatch(){
		parent::preDispatch(); 
		
		$session = SessionWrapper::getInstance(); 
		$session->setVar('applicationtype', APPLICATION_LGMIS); 
	}
	
	function districtAction(){}
	function inputproductionAction(){}
	function businesssectorAction(){
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
	function businesssectorsearchAction(){
		$this->_helper->redirector->gotoSimple("businesssector", "lgmis", 
    											$this->getRequest()->getModuleName(),
    											array_remove_empty(array_merge_maintain_keys($this->_getAllParams(), $this->getRequest()->getQuery())));
	}
	function touristattractionsearchAction(){
		$this->_helper->redirector->gotoSimple("touristattraction", "lgmis", 
    											$this->getRequest()->getModuleName(),
    											array_remove_empty(array_merge_maintain_keys($this->_getAllParams(), $this->getRequest()->getQuery())));
	}
	function touristattractionAction(){
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
	function touristattractiondetailAction(){}
	function livestockproductionAction(){}
	function cropproductionAction(){}
	function fishproductionAction(){} 
	function handcraftsectorAction(){}	
	function loginAction(){}
	
	/**
     * Action to display the Login page 
     */
    public function logoutAction()  {
     	if(isApplicationLGMIS()){
        	$type = 'lgmis';
        }
        if(isApplicationAGMIS() || isApplicationLAMIS()){
        	$type = 'agmis';
        }
    	$this->clearSession();
        // redirect to the login page 
        if($type == 'lgmis'){
        	$this->_helper->redirector("login", "lgmis");
        }
        if($type == 'agmis'){
        	$this->_helper->redirector("login", "user");
        }
    }
}