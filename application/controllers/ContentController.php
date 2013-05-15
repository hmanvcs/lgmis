<?php

class ContentController extends SecureController {

	function getResourceForACL() {
		return "Location Details";
	}
	
	public function getActionforACL() {
		$action = strtolower($this->getRequest()->getActionName()); 
		
		/*if ($action == 'homeview' || $action == 'homeedit') {
			return ACTION_CREATE; 
		}*/
		// return parent::getActionforACL(); 
		return ACTION_VIEW;
	}

	public function viewhomeAction() {
		
	}
	
	public function indexhomeAction() {
		
	}
	
	public function editAction() {
		$this->_translate = Zend_Registry::get("translate");
		$this->_setParam('entityname', 'Content'); 
		$this->_setParam('action', ACTION_EDIT);
		
		$formvalues = $this->_getAllParams();
		// debugMessage($formvalues); // exit();
		$formvalues['id'] = decode($formvalues['id']);
		
		$content = new Content();
		$content->populate($formvalues['id']);
		$submission_data = array();
		$existing_images = $content->getImages()->toArray();
		// debugMessage($existing_images);
		
		foreach ($formvalues['imagesdata'] as $key => $value){
			if(isEmptyString($value['filename'])){
					unset($value[$key]);
			} else {
				$submission_data[$key]['id'] = $value['id'];
				$submission_data[$key]['filename'] = $value['filename'];
				$submission_data[$key]['filepath'] = $value['filepath'];
				$submission_data[$key]['pageid'] = 1;
				$submission_data[$key]['captiontitle'] = $value['captiontitle'];
				$submission_data[$key]['captiondetail'] = $value['captiondetail'];
				$submission_data[$key]['order'] = $value['order'];
				if(isArrayKeyAnEmptyString('hascaption', $value)){
					$submission_data[$key]['hascaption'] = 0;
				} else {
					$submission_data[$key]['hascaption'] = 1;
				}
				if(isArrayKeyAnEmptyString('ispublished', $value)){
					$submission_data[$key]['ispublished'] = 0;
				} else {
					$submission_data[$key]['ispublished'] = 1;
				}
			}	
		}
		//debugMessage($submission_data);
		// unset($formvalues['images']);
		$formatedimages = multidimensional_array_merge($existing_images, $submission_data);
		$formvalues['images'] = $formatedimages;
		// debugMessage($formvalues);
		$content->processPost($formvalues);
		//debugMessage($content->toArray());
		// debugMessage('error is '.$content->getErrorStackAsString());
		
		/*$images_collection = new Doctrine_Collection("ContentImage");
		// process each submission item and add to collection
		foreach ($submission_data as $thedata){
			debugMessage($thedata);
			$contentimage = new ContentImage();
			if(isArrayKeyAnEmptyString('id', $thedata)){
				$contentimage->processPost($thedata);
				debugMessage($contentimage->getErrorStackAsString());
				debugMessage($contentimage->toArray());
				
				if($contentimage->isValid()) {
					$images_collection->add($contentimage);
				}
			} else {
				$contentimage->populate($thedata['id']);
				$contentimage->synchronizeWithArray($thedata, true);
				$images_collection->add($contentimage);
			}
		}
		debugMessage($images_collection->toArray());*/
		
		// save changes to the images
		try {
			// save the collection of crop sectors
			$content->save(); 
			// redirect to success page
			$this->_redirect(decode($this->_getParam(URL_SUCCESS)));
		} catch (Exception $e) {
			$session = SessionWrapper::getInstance(); 
			$session->setVar(FORM_VALUES, $formvalues);
			$session->setVar(ERROR_MESSAGE, $e->getMessage()); 
			// add the errors to the session
			$this->_redirect(decode($this->_getParam(URL_FAILURE)));
		}
		
		// exit();
		return false;
	}
}

