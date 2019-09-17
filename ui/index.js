import 'ol/ol.css';
import {Map, View} from 'ol';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import {transform} from 'ol/proj.js';

const centerLng = 9.13;
const centerLat = 49.34;

let url = "/hot/{z}/{x}/{y}.png";
if (window.location.hostname == 'localhost') {
    // local with domain
    url = "https://maps.egotec.com" + url;
}

const map = new Map({
    target: 'map',
    layers: [
        new TileLayer({
            source: new OSM(
                {
                    attributions: [
                        'All maps © <a href="https://github.com/EGOTEC-GmbH/openstreetmap">EGOTEC GmbH</a>',
                    ],
                    opaque: false,
                    url: url
                }
            )
        })
    ],
    view: new View({
        center: transform([centerLng, centerLat], 'EPSG:4326', 'EPSG:3857'),
        zoom: 0
    })
});