<?php

class LocationdetailController extends SecureController {	
	/**
	 * Get the name of the resource being accessed 
	 *
	 * @return String 
	 */
	function getResourceForACL() {
		return "Location Details"; 
	}
	
	function createAction() {
		$formvalues = $this->_getAllParams();
		// debugMessage($formvalues); exit();
		// if id exists use action edit
		if(!isArrayKeyAnEmptyString('id', $formvalues)){
			$this->_setParam('action', ACTION_EDIT);
		}
		// check if an image was uploaded
		if($this->_getParam('hasimage') == '1'){
			// Only Upload if document for upload exists
			$config = Zend_Registry::get("config"); 
			$this->_translate = Zend_Registry::get("translate"); 
			$session = SessionWrapper::getInstance(); 
			
			// only upload a file if the attachment field is specified		
			$upload = new Zend_File_Transfer();
			$upload->setOptions(array('useByteString' => false));
			
			// File validators
			$upload->addValidator('Extension', false, $config->logo->allowedformats);
		 	$upload->addValidator('Size', false, $config->logo->maximumfilesize);
	 	
			// the document file object before upload
			$file = $upload->getFileInfo('image');
			$oldfilename = $file['image']['name'];
			// debugMessage($file);

			// base path for uploaded 
		 	$destination_path = APPLICATION_PATH.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR.PUBLICFOLDER.DIRECTORY_SEPARATOR.'uploads'.DIRECTORY_SEPARATOR.'lgmis'.DIRECTORY_SEPARATOR.'maps'.DIRECTORY_SEPARATOR;
		 	// debugMessage($destination_path); exit();
		 	// the destination for the uploaded file. Add the matterid to the path
			$upload->setDestination($destination_path);
			
			// rename the base logo file name
			$cur_timestamp = mktime();
			$newfilename = "image_".$cur_timestamp.".".findExtension($oldfilename);
			 
			// debugMessage($newfilename);
			$thefilename = $destination_path.DIRECTORY_SEPARATOR.$newfilename;
			// rename the file to be uploaded using the set timestamp 
			$upload->addFilter('Rename',  array('target' => $destination_path.$newfilename, 'overwrite' => true));
			
			// process the file upload
			if($upload->receive()){
				// the profile image info before upload
				$file = $upload->getFileInfo('image');
				// debugMessage($upload);

				resizeImage($thefilename, $thefilename, 400);
				
				// file has been uploaded. Set logo filename 
				$this->_setParam('image', $newfilename);
				
			} else {
				$uploaderrors = $upload->getMessages();
				$customerrors = array();
				if(!isArrayKeyAnEmptyString('fileExtensionFalse', $uploaderrors)){
					$custom_exterr = sprintf($this->_translate->translate('organisation_invalid_ext_error'), $oldfilename, $config->logo->allowedformats);
					$customerrors['fileExtensionFalse'] = $custom_exterr;
				}
				if(!isArrayKeyAnEmptyString('fileSizeTooBig', $uploaderrors)){
					$customerrors['fileSizeTooBig'] = $uploaderrors['fileSizeTooBig'];
				}
				
				$session->setVar(ERROR_MESSAGE, 'The following errors occured <ul><li>'.implode('</li><li>', $customerrors).'</li></ul>');
				$session->setVar(FORM_VALUES, $this->_getAllParams());
				// return to index page
				$this->_helper->redirector->gotoUrl(decode($this->_getParam(URL_FAILURE)));
			}
		}		
		// exit();
		parent::createAction();
	}
}