import axios from "axios";
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

export async function getRegion(data) {
  const latitude = data.latitude
  const longitude = data.longitude
  const response = await axios.get(`https://nominatim.openstreetmap.org/reverse?lat=${latitude}&lon=${longitude}&format=json`);
  const location = await {...response.data.address, latitude, longitude}
  return await location
}

export function minutesToTime(min) {
  
    const ampm = Math.floor(min / 60) >= 12 ? 'pm' : 'am';
    let hour = Math.floor(min / 60) % 24;
    if (hour > 12) {
      hour -= 12;
    }
    const minute = min % 60 || '00';
    return `${hour}:${minute}${ampm}`;
  
}