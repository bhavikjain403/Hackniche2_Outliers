import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export const generateHex = (size = 8) => {
  const date = new Date();
  const y = date.getFullYear();
  const m = date.getMonth();
  const d = date.getDay();
  const h = date.getHours();
  const min = date.getMinutes();
  const sec = date.getSeconds();
  const ms = date.getMilliseconds();
  const randomHex = [...Array(size)]
    .map(() => Math.floor(Math.random() * 16).toString(16))
    .join('');
  const prefixWithRandom = `${y}${m}${d}${h}${min}${sec}${ms}${randomHex}`;
  return prefixWithRandom;
};
