import Keycloak from "keycloak-js";

export const keycloak = Keycloak({
    realm: "myrealm",
    url: "http://localhost:8888/auth/",
    clientId: "webapp",
});

export const initializeKeycloak = async () => {
    return keycloak.init({
        onLoad: "login-required",
    });
};