import 'ol/ol.css';
import {Map, View} from 'ol';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import {transform} from 'ol/proj.js';

const centerLng = 9.13;
const centerLat = 49.34;

const map = new Map({
    target: 'map',
    layers: [
        new TileLayer({
            source: new OSM(
                {
                    attributions: [
                        'All maps © <a href="https://community.egotec.com/">EGOTEC GmbH</a>',
                    ],
                    opaque: false,
                    url: 'https://maps.egotec.com/hot/{z}/{x}/{y}.png'
                }
            )
        })
    ],
    view: new View({
        center: transform([centerLng, centerLat], 'EPSG:4326', 'EPSG:3857'),
        zoom: 6
    })
});