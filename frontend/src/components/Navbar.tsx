import {Link} from "react-router-dom";
import './Navbar.css'
export default function Navbar() {
    return (
        <nav className="navbar">
            <span className="navbar-brand">Vibecast</span>
            <Link to="/" className="navbar-link">Home</Link>
            <Link to="/history" className="navbar-link">History</Link>
            <Link to="/favorites" className="navbar-link">Favorites</Link>
        </nav>
    )
}