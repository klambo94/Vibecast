import './App.css'
import { Routes, Route } from 'react-router-dom'
import Home from "./pages/Home.tsx";
import Favorites from "./pages/Favorites.tsx";
import History from "./pages/History.tsx";
import Navbar from "./components/Navbar.tsx";

function App() {
    return (
        <>
            <Navbar/>
            <Routes>
                <Route path="/" element={<Home/>}/>
                <Route path="/history" element={<History/>}/>
                <Route path="/favorites" element={<Favorites/>}/>
            </Routes>
        </>
    )
}

export default App
