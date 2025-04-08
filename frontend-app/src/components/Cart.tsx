// import {useEffect, useState} from "react";
import {Dialog, DialogBackdrop, DialogPanel} from "@headlessui/react";
import {TrashIcon} from "@heroicons/react/24/solid";

import {useCart} from "../context/CartContext";

interface iCart {
  open: boolean;
  onClose: () => void;
}
export default function Cart({open, onClose}: iCart) {
  const {cart, getTotal, removeFromCart} = useCart();

  const onCancel = () => {
    onClose();
  };
  const onSave = () => {};
  return (
    <Dialog open={open} onClose={onCancel} className="relative z-10">
      <DialogBackdrop
        transition
        className="fixed inset-0 bg-gray-500/75 transition-opacity data-closed:opacity-0 data-enter:duration-300 data-enter:ease-out data-leave:duration-200 data-leave:ease-in"
      />

      <div className="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div className="flex min-h-full items-end justify-center p-4 text-center md:items-center md:p-0">
          <DialogPanel
            transition
            className="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all data-closed:translate-y-4 data-closed:opacity-0 data-enter:duration-300 data-enter:ease-out data-leave:duration-200 data-leave:ease-in md:my-8 md:w-full md:max-w-lg data-closed:md:translate-y-0 data-closed:md:scale-95"
          >
            <div className="bg-white px-4 pt-5 pb-4 md:p-6 md:pb-4">
              <div className="mt-6 p-4 border-t border-gray-200">
                <h2 className="font-bold text-xl mb-2">Cart</h2>
                <ul>
                  {cart.map((item) => (
                    <li
                      key={item.relationships.product.data.id}
                      className="flex justify-between py-2"
                    >
                      <span>{item.attributes.name}</span>
                      <span>{item.attributes.quantity}</span>
                      <span>${item.attributes.price}</span>
                      <button
                        onClick={() =>
                          item.relationships.product.data.id &&
                          removeFromCart(item.relationships.product.data.id)
                        }
                        className="text-red-500"
                      >
                        <TrashIcon className="size-6 cursor-pointer" />
                      </button>
                    </li>
                  ))}
                </ul>
                <div className="mt-4">
                  <strong>Total:</strong> ${getTotal()}
                </div>
              </div>
            </div>
            <div className="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
              <button
                type="submit"
                onClick={onSave}
                className="inline-flex w-full justify-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-blue-500 sm:ml-3 sm:w-auto"
              >
                Checkout
              </button>
              <button
                type="button"
                data-autofocus
                onClick={onCancel}
                className="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 ring-1 shadow-xs ring-gray-300 ring-inset hover:bg-gray-50 sm:mt-0 sm:w-auto"
              >
                Cancel
              </button>
            </div>
          </DialogPanel>
        </div>
      </div>
    </Dialog>
  );
}
