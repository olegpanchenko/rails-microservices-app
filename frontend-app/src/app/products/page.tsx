"use client";

import React, {useEffect, useState} from "react";
import {useCart} from "../../context/CartContext";
import {fetchProducts, IFilter, JsonApiProduct} from "@/lib/api";

const Products = () => {
  const [products, setProducts] = useState<Array<JsonApiProduct>>([]);
  const [nameFilter, setNameFilter] = useState("");
  const [minPrice, setMinPrice] = useState("");
  const [maxPrice, setMaxPrice] = useState("");
  const {addToCart} = useCart();

  useEffect(() => {
    const filter = {
      name: nameFilter,
      price_min: minPrice,
      price_max: maxPrice,
    };
    loadProducts(filter);
  }, [nameFilter, minPrice, maxPrice]);

  const loadProducts = async (filter: IFilter) => {
    const items = await fetchProducts(filter);
    setProducts(items.data);
  };

  return (
    <div className="max-w-screen-lg mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Product List</h1>

      {/* Filter Section */}
      <div className="mb-4 flex gap-4">
        <input
          type="text"
          placeholder="Search by name"
          value={nameFilter}
          onChange={(e) => setNameFilter(e.target.value)}
          className="p-2 border border-gray-300 rounded"
        />
        <input
          type="number"
          placeholder="Min Price"
          value={minPrice}
          onChange={(e) => setMinPrice(e.target.value)}
          className="p-2 border border-gray-300 rounded"
        />
        <input
          type="number"
          placeholder="Max Price"
          value={maxPrice}
          onChange={(e) => setMaxPrice(e.target.value)}
          className="p-2 border border-gray-300 rounded"
        />
      </div>

      {/* Product List */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {products.map((product) => (
          <div
            key={product.id}
            className="border border-gray-200 p-4 rounded-lg shadow-sm"
          >
            <h3 className="font-semibold text-lg">{product.attributes.name}</h3>
            <p className="text-gray-600">${product.attributes.price}</p>
            <button
              onClick={() => addToCart(product)}
              className="mt-4 bg-blue-500 text-white py-2 px-4 rounded-full"
            >
              Add to Cart
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Products;
