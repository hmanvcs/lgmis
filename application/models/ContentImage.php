<?php

/**
 * Model for the details of a content
 *
 */

class ContentImage extends BaseRecord {
	
	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
		
		$this->setTableName('contentimage');
		$this->hasColumn('filename', 'string', 255, array('notnull' => true, 'notblank'=>true));
		$this->hasColumn('filepath', 'string', 500, array('notnull' => true, 'notblank'=>true));
		$this->hasColumn('pageid', 'integer', null, array('notnull' => true, 'notblank'=>true));
		$this->hasColumn('hascaption', 'integer', null);
		$this->hasColumn('captiontitle', 'string', 50);
		$this->hasColumn('captiondetail', 'string', 500);
		$this->hasColumn('order', 'integer', null);
		$this->hasColumn('ispublished', 'integer', null);
		
	}
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"filename.notblank" => "Please enter image filename",
       									"filepath.notblank" => "Please enter your file path",
       									"pageid.notblank" => "Please enter "
       	       						));
	}
	public function setUp() {
		parent::setUp(); 
		
		// the page for this image
		$this->hasOne('Content as theimage',
						 array(
								'local' => 'pageid',
								'foreign' => 'id'
							)
					); 
	}
	
	function processPost($formvalues){
		//unset number fields that can be empty
		if (isArrayKeyAnEmptyString('order', $formvalues)) {
			unset($formvalues['order']); 
		}
		if (isArrayKeyAnEmptyString('ispublished', $formvalues)) {
			unset($formvalues['ispublished']); 
		}
		if (isArrayKeyAnEmptyString('hascaption', $formvalues)) {
			unset($formvalues['hascaption']); 
		}
		// debugMessage($formvalues);		
		parent::processPost($formvalues);
	}
	# determine if image is published for viewing 
	function isViewable() {
		return $this->getIsPublished() == '1' ? true : false;
	}
}
?>