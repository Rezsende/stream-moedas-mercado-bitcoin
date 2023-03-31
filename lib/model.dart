class DataModel

{
	  
		String buy;
    String volume;

    DataModel({
      required this.buy,
      required this.volume,
    });
		
    DataModel.fromJson(Map<String, dynamic> json)
    :
    buy = json['ticker']['buy'] ?? "",
    volume = json['ticker']['vol']?? "";
    
          
}



