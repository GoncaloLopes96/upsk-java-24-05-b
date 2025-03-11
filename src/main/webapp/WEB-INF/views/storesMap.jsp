<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CashMe - Lojas</title>

    <!-- Importação do Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Importação dos estilos personalizados -->
    <link rel="stylesheet" href="/styles/fonts.css">
    <link rel="stylesheet" href="/styles/buttons.css">
    <link rel="stylesheet" href="/styles/forms.css">
    <link rel="stylesheet" href="/styles/custom.css">
    <link rel="stylesheet" href="/styles/footer.css">
    <link rel="stylesheet" href="/styles/header.css">
</head>
<body>

<%@ include file="includes/header.jsp" %> <!-- Navbar -->

<section class="container mt-4 mb-6">
    <h2 class="fw-bold">Encontre uma loja</h2>
    <div class="row mt-3">
        <!-- Lista de Lojas com Scroll -->
        <div class="col-md-4">
            <input type="text" id="searchBox" class="form-control mb-3" placeholder="Procure por Nome ou Região" onkeyup="filterStores()">
            <p class="text-muted" id="totalStores">Carregando lojas...</p>

            <!-- Wrapper com altura controlada -->
            <div id="storeList" class="list-group border rounded shadow-sm"></div>
        </div>

        <!-- Mapa do Google Maps -->
        <div class="col-md-8 mb-6">
            <div id="map" class="rounded shadow-sm w-100" style="height: 500px;"></div>
        </div>
    </div>
</section>

<!-- Footer -->
<%@ include file="includes/footer.jsp"%>

<script>
    let map;
    let markers = [];

    function initMap() {
        const initialLocation = { lat: 38.7169, lng: -9.1399 }; // Lisboa

        map = new google.maps.Map(document.getElementById("map"), {
            center: initialLocation,
            zoom: 12,
        });

        fetchStoresWithStatus();
    }

    function fetchStoresWithStatus() {
        fetch('/api/status')
            .then(response => response.json())
            .then(stores => {
                const storeList = document.getElementById("storeList");
                storeList.innerHTML = "";

                stores.forEach(store => {
                    addStoreMarker(store);

                    const openingTime = store.openingTime ? store.openingTime.substring(0, 5) : "-";
                    const closingTime = store.closingTime ? store.closingTime.substring(0, 5) : "-";
                    let statusClass = "text-danger";
                    let statusText = "Indisponível";

                    if (store.status === 'Aberto') {
                        statusClass = "text-success";
                        statusText = `Aberto <span class= 'text-dark'> - Fecha às` + " " + closingTime +`</span>`;
                    } else if (store.status === 'Fechado') {
                        statusClass = "text-danger";
                        statusText = `Fechado <span class='text-dark'> - Abre às ` + " " + openingTime + `</span>`;
                    }

                    const storeItem = document.createElement("div");
                    storeItem.classList.add("list-group-item", "border-0");
                    storeItem.innerHTML = `
                        <div class="d-flex align-items-center">
                            <img src="/images/` + store.imageUrl + `" alt="` + store.name + `" class="me-2" style="width: 50px; height: 50px;">
                            <div>
                                <h5 class="fw-bold">` + store.name + `</h5>
                                <p class="mb-1">` + store.location + ` </p>
                                <p class="` + statusClass + ` fw-bold">` + statusText + `</p>
                                <p class='text-dark'> <b>Horário: </b>` + openingTime + ` - ` + closingTime + ` </p>
                            </div>
                        </div>
                    `;
                    storeList.appendChild(storeItem);
                });

                document.getElementById("totalStores").innerText = stores.length + ` lojas encontradas`;
            })
            .catch(error => {
                console.error("Erro ao carregar lojas:", error);
                alert("Erro ao carregar lojas. Verifique se a API está acessível.");
            });
    }


    function addStoreMarker(store) {
        if (store.latitude !== 0.0 && store.longitude !== 0.0) {
            const marker = new google.maps.Marker({
                position: { lat: store.latitude, lng: store.longitude },
                map: map,
                title: store.name,
            });

            let statusClass = "text-danger";
            if (store.status === 'Aberto') {
                statusClass = "text-success";
            }

            const infoWindow = new google.maps.InfoWindow({
                content: `
                    <div style="text-align: center;">
                        <h6>\${store.name}</h6>
                        <img src="/images/\${store.imageUrl}" alt="\${store.name}" style="width: 100px; height: 100px; border-radius: 8px; margin-bottom: 5px;">
                        <p>\${store.location}</p>
                        <p class="\${statusClass} fw-bold">\${store.status}</p>
                    </div>
                `,
            });

            marker.addListener("click", () => {
                infoWindow.open(map, marker);
            });

            markers.push(marker);
        }
    }

    function formatTime(time) {
        return time.substring(0, 5); // Transforma "08:30:00" em "08:30"
    }

    function filterStores() {
        const query = document.getElementById("searchBox").value.toLowerCase().trim();
        const storeItems = document.querySelectorAll(".list-group-item");
        let visibleCount = 0;

        storeItems.forEach(item => {
            const name = item.querySelector("h5")?.textContent.toLowerCase() || "";
            const location = item.querySelector("p.mb-1")?.textContent.toLowerCase() || "";

            if (name.includes(query) || location.includes(query)) {
                item.style.display = "block";
                visibleCount++;
            } else {
                item.style.display = "none";
            }
        });

        document.getElementById("totalStores").innerText = visibleCount + ` lojas encontradas`;
    }

    document.getElementById("searchBox").addEventListener("keypress", function(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            filterStores();
        }
    });


</script>

<!-- Google Maps API -->
<script src="" defer></script>

</body>
</html>



