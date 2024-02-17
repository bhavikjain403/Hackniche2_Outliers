// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCY8ExAZZIXvS_8KZsZPQC6ekIeA90NXrs",
  authDomain: "nomnom-7ef89.firebaseapp.com",
  projectId: "nomnom-7ef89",
  storageBucket: "nomnom-7ef89.appspot.com",
  messagingSenderId: "118350703238",
  appId: "1:118350703238:web:a486c53d8260f82413ff07",
  measurementId: "G-QNNN21P3VZ"
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const firebaseAuth = getAuth(app);
export const db = getFirestore(app)
