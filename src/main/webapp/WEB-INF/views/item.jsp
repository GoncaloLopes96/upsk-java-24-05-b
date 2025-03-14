<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CashMe - Produto</title>

    <!-- Importação do Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Importação dos estilos personalizados -->
    <link rel="stylesheet" href="/styles/fonts.css">
    <link rel="stylesheet" href="/styles/buttons.css">
    <link rel="stylesheet" href="/styles/forms.css">
    <link rel="stylesheet" href="/styles/custom.css">
    <link rel="stylesheet" href="/styles/footer.css">
    <link rel="stylesheet" href="/styles/header.css">

    <!-- Para o icone da wishlist -->
    <style>
        .image-container {
            position: relative;
        }
        .icons-container {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .icon {
            width: 24px;
            height: 24px;
        }
    </style>

</head>
<body>

<%@ include file="includes/header.jsp" %> <!-- Navbar -->

<section class="container mt-5">
    <div class="row">
        <!-- Galeria de Imagens -->
        <div class="col-md-5">
            <div class="image-container">
                <img src="/images/${item.imageUrl}" alt="${item.name}" class="img-fluid w-100 border rounded">
                <!-- Botão Wishlist -->
                <div class="icons-container position-absolute top-0 end-0 p-2">
                    <button onclick="toggleWishlist(${item.id}, event)" type="button" class="icons-container">
                        <img id="wishlist-icon-${item.id}"
                             src="/images/${item.inWishlist ? 'heartfill.svg' : 'heart.svg'}"
                             alt="Favorito"
                             class="icon"
                             data-in-wishlist="${item.inWishlist ? 'true' : 'false'}">
                    </button>
                </div>
            </div>
        </div>

        <!-- Informações do Produto -->
        <div class="col-md-7 d-flex flex-column justify-content-center">
            <h2 class="fw-bold">${item.name}</h2>

            <!-- Avaliação Clicável -->
            <div class="d-flex align-items-center">
                <div class="rating text-warning">
                    <div class="rating mt-2" id="rating-${item.id}">
                        <c:forEach var="i" begin="1" end="5">
                            <span class="star"
                                  data-value="${i}"
                                  onclick="rateItem(${item.id}, ${i}, event)">${item.rating >= i ? "&#9733;" : "&#9734;"}</span>
                        </c:forEach>
                        <span class="rating-value">(${item.reviewsCount} Reviews)</span>
                    </div>
                </div>
                <span class="text-success ms-3 mt-2">Em stock</span>
            </div>

            <!-- Preço Formatado -->
            <h3 class="mt-3 text-primary fw-bold">${item.formattedPrice}</h3>

            <p class="mt-2">${item.description}</p>

            <!-- Seletor de Quantidade -->
            <div class="d-flex align-items-center mt-3">
                <button class="btn btn-outline-secondary quantity-btn" onclick="updateQuantity(-1)">-</button>
                <span class="mx-3 fs-5" id="quantity">1</span>
                <button class="btn btn-outline-secondary quantity-btn" onclick="updateQuantity(1)">+</button>
                <button id="addToCart" class="btn btn-primary px-4 ms-3" data-item-id="${item.id}">Adicionar ao carrinho</button>
            </div>

        </div>
    </div>
</section>

<!-- Disponibilidade nas Lojas -->
<section class="container mt-5">
    <div class="d-flex align-items-center">
        <img src="/images/rectangleBullet.svg" alt="Bullet" class="img-fluid">
        <h4 class="ms-3">Disponível em:</h4>
    </div>

    <div class="row mt-4 mb-6">
        <c:if test="${!stores.isEmpty()}">
            <c:forEach var="store" items="${stores}">
            <div class="col-md-3 text-center">
                <img src="/images/${store.imageUrl == null ? 'store-placeholder.svg' : store.imageUrl}" alt="Loja" class="img-fluid">
            </div>
            </c:forEach>
        </c:if>
        <c:if test="${stores.isEmpty()}">
            <p class="text-muted">Este produto não está disponível em nenhuma loja.</p>
        </c:if>
    </div>
</section>

<%@ include file="includes/footer.jsp" %> <!-- Footer -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/scripts/scripts.js" defer></script>


<script>
    function toggleWishlist(itemId, event) {
        event.preventDefault();
        event.stopPropagation();

        let heartIcon = document.getElementById("wishlist-icon-" + itemId);
        let isCurrentlyInWishlist = heartIcon.dataset.inWishlist === "true";

        fetch("/wishlist/toggle/" + itemId, {
            method: "POST"
        })
            .then(response => {
                if (response.ok) {
                    // Atualiza o ícone sem recarregar a página
                    heartIcon.src = isCurrentlyInWishlist ? "/images/heart.svg" : "/images/heartfill.svg";
                    heartIcon.dataset.inWishlist = isCurrentlyInWishlist ? "false" : "true";
                } else {
                    //alert("Erro ao atualizar a wishlist");
                }
            })
            .catch(error => {
                console.error("Erro ao atualizar a wishlist:", error);
            });
    }
</script>

<script>
    function updateQuantity(amount) {
        const quantityElement = document.getElementById('quantity');
        let quantity = parseInt(quantityElement.textContent);
        quantity = Math.max(1, quantity + amount);
        quantityElement.textContent = quantity;
    }

    document.getElementById("addToCart").addEventListener("click", function () {
        let button = document.getElementById("addToCart");
        let itemId = button.getAttribute("data-item-id"); // Obtém o itemId do botão
        let quantity = parseInt(document.getElementById('quantity').textContent);

        if (!itemId || isNaN(quantity) || quantity < 1) {
            console.error("Erro: Item ID inválido ou quantidade incorreta.");
            alert("Erro ao adicionar ao carrinho.");
            return;
        }

        // Converte itemId para número para evitar problemas de conversão no backend
        let url = new URL(window.location.origin + "/cart/addItemToCart");
        url.searchParams.append("itemId", itemId);
        url.searchParams.append("quantity", quantity);

        fetch(url.toString(), {
            method: "GET",
            headers: { "Content-Type": "application/json" }
        })
            .then(response => response.text())
            .then(data => {
                if (data.includes("ok")) {
                    window.location.href = "/cart"; // Redireciona para o carrinho
                } else {
                    alert(data.replace("error: ", "")); // Exibe mensagem de erro do backend
                }
            })
            .catch(error => {
                console.error("Erro ao adicionar ao carrinho:", error);
            });
    });

</script>

</body>
</html>


