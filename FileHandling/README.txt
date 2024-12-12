Problem Statement :- 
The goal is to read data from popular file formats (.csv, .txt, .json), to perform operations on this data, and to finally save this modified data into the original file formats.

# Data Description
The dataset for this project has been provided in the *mainfolder.zip* file. It contains data about products for which the unique ID provided is the stock keeping unit or SKU for short. The ZIP file contains a structured collection of sales data and product information organized into a main folder with three key components:

- **Sales Data** (*sales_data.csv*): A CSV file that includes sales data for various products over a 14-day period. Each row corresponds to a different product, identified by a *Product_SKU*. The columns *Day1* through *Day14* represent the sales figures for each consecutive day.

- **Product Descriptions** (*product_descriptions* folder): This folder contains text files, each corresponding to a specific product identified by the SKU in the filename (e.g., *description_AISJDKFJW93NJ.txt*). These files provide descriptive information about the products.

- **Product Details** (*product_details* folder): This folder includes JSON files, again with filenames corresponding to product SKUs (e.g., *details_AISJDKFJW93NJ.json*). These files contain detailed attributes of the products, such as specifications, category, pricing, etc.

This dataset is suitable for analyzing daily sales performance of products, supplemented with detailed product information and descriptions to allow for a comprehensive analysis of sales trends in relation to product attributes and descriptions.
