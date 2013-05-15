<?php

/**
 * Model for a Tourist attraction in a 
 *
 */

class TouristAttraction extends BaseEntity {

	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
				
		$this->setTableName('touristattraction');
		
		$this->hasColumn('name', 'string', 255, array('notnull' => true, 'notblank' => true)); 
		$this->hasColumn('physicallocation', 'string', 1000); 
		$this->hasColumn('districtid', 'integer', 11, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('subcountyid', 'integer');
		$this->hasColumn('touristattractions', 'string', 65535);
		$this->hasColumn('priceoffers', 'string', 65535);
		$this->hasColumn('accomodation', 'string', 65535);
		$this->hasColumn('entertainment', 'string', 65535);
		$this->hasColumn('transport', 'string', 65535);
		$this->hasColumn('otherservices', 'string', 65535);
		$this->hasColumn('booking', 'string', 65535);
		$this->hasColumn('tourpackages', 'string', 65535);
		$this->hasColumn('contact',  'string', 65535);
		$this->hasColumn('image','string', 255);
	} 
	
	public function setUp() {
		parent::setUp(); 
		
		$this->hasOne('District as district',
						 array(
								'local' => 'districtid',
								'foreign' => 'id'
							)
					); 
		// use a Location since it may be both subcounty and Municipality
		$this->hasOne('County as subcounty',
						 array(
								'local' => 'subcountyid',
								'foreign' => 'id'
							)
					); 
	} 
	function processPost($formvalues){
		//unset the none number attributes if they are not required fields
		if(isArrayKeyAnEmptyString('subcountyid', $formvalues)){
			unset($formvalues['subcountyid']); 
		}
		parent::processPost($formvalues);
	}
	/**
	 * image path
	 */	
	function getImagePath() {
		// return empty string if empty
		$path = '--';
		$baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();
		
		if(!isEmptyString($this->getImage()) && $this->hasIDImage()){
			$path = $baseUrl.'/uploads/tourism/'.$this->getImage();
		}
		
		return $path; 
	}
	# determine if image already exists with 
	function hasIDImage(){
		// $real_path = APPLICATION_PATH."/../public/uploads/commodity";
		$real_path = APPLICATION_PATH.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR.PUBLICFOLDER.DIRECTORY_SEPARATOR.'uploads'.DIRECTORY_SEPARATOR.'tourism';
		$real_path = $real_path.DIRECTORY_SEPARATOR.$this->getImage();
		if(file_exists($real_path)){
			return true;
		}
		return false;
	}
}

?>