<?php

/**
 * Model for the details of a content
 *
 */

class Content extends BaseEntity {
	
	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
		
		$this->setTableName('content');
		$this->hasColumn('pagetitle', 'string', 25, array('notnull' => true, 'notblank'=>true));
		$this->hasColumn('pagename', 'string', 50, array('notnull' => true, 'notblank'=>true));
		$this->hasColumn('locationid', 'integer', null);
		$this->hasColumn('summary', 'string', 1000);
		$this->hasColumn('leftcolumnone', 'string', 65535);
		$this->hasColumn('leftcolumntwo', 'string', 65535);
		$this->hasColumn('leftcolumnthree', 'string', 65535);
		$this->hasColumn('rightcolumnone', 'string', 65535);
		$this->hasColumn('rightcolumntwo', 'string', 65535);
		$this->hasColumn('rightcolumnthree', 'string', 65535);
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
       									"pagetitle.notblank" => "Please enter Page Title",
       									"pagename.notblank" => "Please enter Page Name"
       	       						));
	}
	public function setUp() {
		parent::setUp(); 
		
		// the location for which the details are being provided
		$this->hasOne('District as location',
						 array(
								'local' => 'locationid',
								'foreign' => 'id'
							)
					);
		$this->hasMany('ContentImage as images',
							array('local' => 'id',
									'foreign' => 'pageid'
							)
						); 
	}
	# preprocess
	function processPost($formvalues){
		// check if the locationid is specified
		if (isArrayKeyAnEmptyString('locationid', $formvalues)) {
			unset($formvalues['locationid']);
		}
		//unset number fields that can be empty
		if (isArrayKeyAnEmptyString('order', $formvalues)) {
			unset($formvalues['order']); 
		}
		if (isArrayKeyAnEmptyString('ispublished', $formvalues)) {
			unset($formvalues['ispublished']); 
		}
		// debugMessage($formvalues);		
		parent::processPost($formvalues);
	}
	# return collection of page images
	function getImageList() {
		$q = Doctrine_Query::create()
		->from('ContentImage ci')
		->where("ci.pageid = '".$this->getID()."' ")
		->orderby("ci.order ASC, ci.id ASC");
		return $q->execute();
	}
}
?>