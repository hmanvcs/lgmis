<?php

/**
 * Model for the details of a location
 *
 */

class LocationDetail extends BaseEntity {
	
	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
		
		$this->setTableName('locationdetail');
		$this->hasColumn('locationid', 'integer', null, array('unique'=> true, 'notnull' => true, 'notblank'=>true));
		$this->hasColumn('summary', 'string', 65535);
		$this->hasColumn('agriculturalinputprices', 'string', 65535);
		$this->hasColumn('businesssector', 'string', 65535);
		$this->hasColumn('tourismsector', 'string', 65535);
		$this->hasColumn('cropproduction', 'string', 65535);
		$this->hasColumn('livestockproduction', 'string', 65535);
		$this->hasColumn('handcraftsector', 'string', 65535);
		$this->hasColumn('fishproduction', 'string', 65535);
		$this->hasColumn('image','string', 255);
	}
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"locationid.notblank" => "Please select a District",
       									"locationid.unique" => "District you are trying to Setup already exists."
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
	}
	
	# save new district price source 
	function afterSave() {
		$session = SessionWrapper::getInstance();
		$pricesoure_array = array(
			"applicationtype" => APPLICATION_LGMIS,
			"locationid" => $this->getLocationID(),
			"name" => $this->getLocation()->getName(). " District Price Source",
			"contactperson" => "Coming soon",
			"phone" => "2567XXXXXXX",
			"address" => $this->getLocation()->getName(),
			"createdby" => $session->getVar('userid'),
			"pricecategories" => array(
				"0" => array("pricecategoryid" => 6)
			)			
		);
		
		$source = new PriceSource();
		$source->processPost($pricesoure_array);
		// debugMessage($source->toArray());
		//exit();
		if(!$source->hasError()){
			$source->save();
		}
		
		return true;
	}
	# save new district price source 
	function afterUpdate() {
		$session = SessionWrapper::getInstance();
		
		$pricesoure_array = array(
			"applicationtype" => APPLICATION_LGMIS,
			"locationid" => $this->getLocationID(),
			"name" => $this->getLocation()->getName(). " District Price Source",
			"contactperson" => "Coming soon",
			"phone" => "2567XXXXXXX",
			"address" => $this->getLocation()->getName(),
			"createdby" => $session->getVar('userid'),
			"pricecategories" => array(
				"0" => array("pricecategoryid" => 6)
			)			
		);
		
		$source = new PriceSource();
		$source->processPost($pricesoure_array);
		// debugMessage($source->toArray());
		//exit();
		if(!$source->hasError()){
			$source->save();
		}
		
		return true;
	}
	function getMarketLocation(){
		
	}
	/**
	 * image path
	 */	
	function getImagePath() {
		// return empty string if empty
		$path = '--';
		$baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();
		
		$mapfilename = !isEmptyString($this->getImage()) ? $this->getImage() : $this->getLocationID().'.jpg';
		if($this->hasIDImage()){
			$path = $baseUrl.'/uploads/lgmis/maps/'.$this->getLocationID().".jpg";
		}
		if(!isEmptyString($this->getImage())){
			$path = $baseUrl.'/uploads/lgmis/maps/'.$this->getImage();
		}
		
		return $path; 
	}
	# determine if image already exists with 
	function hasIDImage(){
		$real_path = APPLICATION_PATH.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR.PUBLICFOLDER.DIRECTORY_SEPARATOR.'uploads'.DIRECTORY_SEPARATOR.'lgmis'.DIRECTORY_SEPARATOR.'maps';
		$real_path = $real_path.DIRECTORY_SEPARATOR.$this->getLocationID().".jpg";
		// debugMessage($real_path);
		if(file_exists($real_path)){
			return true;
		}
		return false;
	}
	# determine if image with timestamp already exists 
	function hasImage(){
		$real_path = APPLICATION_PATH.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR.PUBLICFOLDER.DIRECTORY_SEPARATOR.'uploads'.DIRECTORY_SEPARATOR.'lgmis'.DIRECTORY_SEPARATOR.'maps';
		$real_path = $real_path.DIRECTORY_SEPARATOR.$this->getImage();
		// debugMessage($real_path);
		if(file_exists($real_path)){
			return true;
		}
		return false;
	}
}

?>