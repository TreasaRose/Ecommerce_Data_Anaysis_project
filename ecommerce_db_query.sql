/******  About the database and tables******/
CREATE DATABASE [ecommercedb]

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Categories]******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Categories](
	[product_category_name] [nvarchar](50) NOT NULL,
	[product_category_name_english] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[product_category_name] ASC,
	[product_category_name_english] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Customers] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customers](
	[customer_id] [nvarchar](50) NOT NULL,
	[customer_unique_id] [nvarchar](50) NOT NULL,
	[customer_zip_code_prefix] [int] NOT NULL,
	[customer_city] [nvarchar](50) NOT NULL,
	[customer_state] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Geolocation1-zip_code_prefix] FOREIGN KEY([customer_zip_code_prefix])
REFERENCES [dbo].[Geolocation] ([geolocation_zip_code_prefix])
GO

ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Geolocation1-zip_code_prefix]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Geolocation] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Geolocation](
	[geolocation_zip_code_prefix] [int] NOT NULL,
	[geolocation_lat] [float] NULL,
	[geolocation_lng] [float] NULL,
	[geolocation_city] [nvarchar](50) NULL,
	[geolocation_state] [nvarchar](50) NULL,
 CONSTRAINT [pk_geolocation] PRIMARY KEY CLUSTERED 
(
	[geolocation_zip_code_prefix] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Order Items] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order Items](
	[order_id] [nvarchar](50) NOT NULL,
	[order_item_id] [tinyint] NOT NULL,
	[product_id] [nvarchar](50) NOT NULL,
	[seller_id] [nvarchar](50) NOT NULL,
	[shipping_limit_date] [datetime2](7) NOT NULL,
	[price] [float] NOT NULL,
	[freight_value] [float] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Order Items]  WITH CHECK ADD  CONSTRAINT [fk_order_items_order-order_id] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO

ALTER TABLE [dbo].[Order Items] CHECK CONSTRAINT [fk_order_items_order-order_id]
GO

ALTER TABLE [dbo].[Order Items]  WITH CHECK ADD  CONSTRAINT [fk_order_items_product-product_id] FOREIGN KEY([product_id])
REFERENCES [dbo].[Products] ([product_id])
GO

ALTER TABLE [dbo].[Order Items] CHECK CONSTRAINT [fk_order_items_product-product_id]
GO

ALTER TABLE [dbo].[Order Items]  WITH CHECK ADD  CONSTRAINT [fk_order_items_seller-seller_id] FOREIGN KEY([seller_id])
REFERENCES [dbo].[Sellers] ([seller_id])
GO

ALTER TABLE [dbo].[Order Items] CHECK CONSTRAINT [fk_order_items_seller-seller_id]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Order Payments] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order Payments](
	[order_id] [nvarchar](50) NOT NULL,
	[payment_sequential] [tinyint] NOT NULL,
	[payment_type] [nvarchar](50) NOT NULL,
	[payment_installments] [tinyint] NOT NULL,
	[payment_value] [float] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Order Payments]  WITH CHECK ADD  CONSTRAINT [fk_Order_Payments_order- order_id] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO

ALTER TABLE [dbo].[Order Payments] CHECK CONSTRAINT [fk_Order_Payments_order- order_id]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Orders]******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Orders](
	[order_id] [nvarchar](50) NOT NULL,
	[customer_id] [nvarchar](50) NOT NULL,
	[order_status] [nvarchar](50) NOT NULL,
	[order_purchase_timestamp] [datetime2](7) NOT NULL,
	[order_approved_at] [datetime2](7) NULL,
	[order_delivered_carrier_date] [datetime2](7) NULL,
	[order_delivered_customer_date] [datetime2](7) NULL,
	[order_estimated_delivery_date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [fk_orders_customer-customer_id] FOREIGN KEY([customer_id])
REFERENCES [dbo].[Customers] ([customer_id])
GO

ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [fk_orders_customer-customer_id]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Products]******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Products](
	[product_id] [nvarchar](50) NOT NULL,
	[product_category_name] [nvarchar](50) NULL,
	[product_name_lenght] [int] NULL,
	[product_description_lenght] [int] NULL,
	[product_photos_qty] [tinyint] NULL,
	[product_weight_g] [int] NULL,
	[product_length_cm] [tinyint] NULL,
	[product_height_cm] [tinyint] NULL,
	[product_width_cm] [tinyint] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Reviews]******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Reviews](
	[review_id] [nvarchar](50) NOT NULL,
	[order_id] [nvarchar](50) NOT NULL,
	[review_score] [tinyint] NOT NULL,
	[review_comment_title] [nvarchar](50) NULL,
	[review_comment_message] [nvarchar](250) NULL,
	[review_creation_date] [datetime2](7) NOT NULL,
	[review_answer_timestamp] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [fk_reviews_order - order_id] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO

ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [fk_reviews_order - order_id]
GO

USE [ecommercedb]
GO

/****** Object:  Table [dbo].[Sellers] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sellers](
	[seller_id] [nvarchar](50) NOT NULL,
	[seller_zip_code_prefix] [int] NOT NULL,
	[seller_city] [nvarchar](50) NOT NULL,
	[seller_state] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Sellers] PRIMARY KEY CLUSTERED 
(
	[seller_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Sellers]  WITH CHECK ADD  CONSTRAINT [fk_sellers_geolocation-zip_code_prefix] FOREIGN KEY([seller_zip_code_prefix])
REFERENCES [dbo].[Geolocation] ([geolocation_zip_code_prefix])
GO

ALTER TABLE [dbo].[Sellers] CHECK CONSTRAINT [fk_sellers_geolocation-zip_code_prefix]
GO

