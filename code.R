
# Read the customer_churn data from the CSV file
df <- read.csv("./customer_churn.csv")

revenue_cube <- 
  tapply(df$Total.Revenue, 
         df[,c("Contract", "Offer", "Internet.Type","Customer.Status")], 
         FUN=function(x){return(sum(x))})


sub_data =apply(revenue_cube, c("Contract", "Offer","Internet.Type"),
                FUN=function(x) {return(sum(x, na.rm=TRUE))}) 
#a. The total revenue contribution from a Two Year contract for each Offer by internet type.
sub_data["Two Year" , , ]

totalNo = sum(revenue_cube[,"Offer B",,],na.rm = TRUE)
churned = revenue_cube["Month-to-Month","Offer B","Cable","Churned"]

#b.
percentChurned = churned/totalNo * 100
cat("Total revenue by churned customers that accepted a
Month-to-Month contract for Cable service= ", format(percentChurned, digits = 2), "%")

