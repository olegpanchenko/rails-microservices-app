"use client";

import {AuthProvider, useAuth} from "@/context/AuthContext";
import {CartProvider, useCart} from "@/context/CartContext";
import Link from "next/link";
import {ShoppingCartIcon} from "@heroicons/react/24/solid";
import Cart from "@/components/Cart";

export function Header() {
  const {logout, isAuthenticated, currentUser} = useAuth();

  const {cart, showCart, setShowCart} = useCart();

  const openCart = () => {
    setShowCart(true);
  };

  const closeCart = () => {
    setShowCart(false);
  };

  return (
    <>
      <header className="w-full bg-gray-800 text-white p-4">
        <div className="container mx-auto flex justify-between items-center">
          <div className="text-xl font-semibold">
            <Link href="/products"></Link>
          </div>

          <div className="flex items-center space-x-4 relative">
            {isAuthenticated && currentUser ? (
              <div id="auth-links">
                <span id="user-email" className="text-sm mr-5">
                  {currentUser.attributes.email}
                </span>
                <button
                  className="bg-red-500 text-white px-4 py-2 rounded"
                  id="logout-btn"
                  onClick={logout}
                >
                  Logout
                </button>
              </div>
            ) : (
              <div id="guest-links" className="flex space-x-4">
                <Link
                  id="login-btn"
                  className="bg-blue-500 text-white px-4 py-2 rounded"
                  href="/login"
                >
                  Login
                </Link>
                <Link
                  id="register-btn"
                  className="bg-green-500 text-white px-4 py-2 rounded"
                  href="/signup"
                >
                  Sign Up
                </Link>
              </div>
            )}
            <ShoppingCartIcon
              className="size-6 cursor-pointer"
              onClick={() => openCart()}
            />
            {cart.length > 0 && (
              <span className="absolute top-0 right-0 rounded-full bg-red-500 text-white text-xs font-bold px-2 py-1">
                {cart.length}
              </span>
            )}
          </div>
        </div>
      </header>
      <Cart open={showCart} onClose={closeCart} />
    </>
  );
}

export default function App({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <AuthProvider>
      <CartProvider>
        <Header />
        {children}
      </CartProvider>
    </AuthProvider>
  );
}
