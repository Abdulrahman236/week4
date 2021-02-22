contract mapping_example { 
      
  mapping (string => string) cities;
  
  
  function add(string memory _city, string memory _country) public{
      cities[_city] = _country;
  }
  
  function get(string memory _city) public view returns(string memory){
      return cities[_city];
  }
  
  function remove(string memory _city) public{
      delete(cities[_city]);
  }
  
}