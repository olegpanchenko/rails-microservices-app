"use client";

import {JsonApiOrderItem, JsonApiProduct} from "@/lib/api";
import React, {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";

interface CartProviderProps {
  children: ReactNode;
}

interface CartContextType {
  cart: Array<JsonApiOrderItem>;
  addToCart: (product: JsonApiProduct) => void;
  getTotal: () => number;
  removeFromCart: (productId: number) => void;
  showCart: boolean;
  setShowCart: (val: boolean) => void;
}

const CartContext = createContext<CartContextType>({
  cart: [] as Array<JsonApiOrderItem>,
  addToCart: () => {},
  getTotal: () => 0,
  removeFromCart: () => {},
  showCart: false,
  setShowCart: () => {},
});

export const useCart = () => {
  return useContext(CartContext);
};

export const CartProvider: React.FC<CartProviderProps> = ({children}) => {
  const [cart, setCart] = useState<Array<JsonApiOrderItem>>([]);
  const [showCart, setShowCart] = useState(false);

  useEffect(() => {
    loadCart();
  }, []);

  const loadCart = () => {
    const savedCart = localStorage.getItem("cart");

    setCart(savedCart ? JSON.parse(savedCart) : []);
  };

  const addToCart = (product: JsonApiProduct) => {
    const orderItemIndex = cart.findIndex(
      (item: JsonApiOrderItem) =>
        item.relationships.product.data.id === product.id
    );
    if (orderItemIndex >= 0) {
      const updatedCart = cart.map((item) => {
        if (item.relationships.product.data.id === product.id) {
          item.attributes.quantity = item.attributes.quantity + 1;
        }
        return item;
      });

      localStorage.setItem("cart", JSON.stringify(updatedCart));

      setCart(updatedCart);
    } else {
      const orderItem = {
        type: "order_items",
        attributes: {
          quantity: 1,
          price: product.attributes.price,
          name: product.attributes.name,
        },
        relationships: {
          product: {
            data: product,
          },
        },
      } as JsonApiOrderItem;
      setCart((prevCart) => {
        const newCart = [...prevCart, orderItem];
        localStorage.setItem("cart", JSON.stringify(newCart));
        return newCart;
      });
    }
  };

  const getTotal = () => {
    const total = cart.reduce((total, item) => {
      return total + item.attributes.price * item.attributes.quantity;
    }, 0);
    return Math.round(total * 100) / 100;
  };

  const removeFromCart = (productId: number) => {
    setCart((prevCart) => {
      const newCart = prevCart.filter(
        (item) => item.relationships.product.data.id !== productId
      );
      localStorage.setItem("cart", JSON.stringify(newCart));
      return newCart;
    });
  };

  return (
    <CartContext.Provider
      value={{cart, addToCart, getTotal, removeFromCart, showCart, setShowCart}}
    >
      {children}
    </CartContext.Provider>
  );
};
