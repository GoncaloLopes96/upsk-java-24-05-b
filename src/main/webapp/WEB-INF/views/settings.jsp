<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>CashMe - Definições</title>

    <!-- Importação do Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <!-- Importação dos estilos personalizados -->
    <link rel="stylesheet" href="/styles/fonts.css">
    <link rel="stylesheet" href="/styles/buttons.css">
    <link rel="stylesheet" href="/styles/forms.css">
    <link rel="stylesheet" href="/styles/custom.css">
    <link rel="stylesheet" href="/styles/footer.css">
    <link rel="stylesheet" href="/styles/header.css">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>

</head>
<body>

<%@ include file="includes/header.jsp" %> <!-- Navbar -->

<!-- Breadcrumb -->
<section class="container mt-4">
    <p><a href="/mainPage" class="text-decoration-none text-dark">Home</a> / <b>Definições</b></p>
</section>

<!-- Seção Principal -->
<section class="container mt-4">
    <div class="row aling-items center mb-6">
        <!-- Sidebar de navegação -->
        <div class="col-md-3">
            <div class="p-4 border rounded shadow-sm">
                <h5 class="fw-bold">Gestão de Conta</h5>
                <ul class="list-unstyled mt-3">
                    <li><a href="/account" class="text-decoration-none text-muted">O meu perfil</a></li>
                    <li><a href="/account/paymentMethods" class="text-decoration-none text-muted">Opções de Pagamento</a></li>
                </ul>
                <h5 class="fw-bold mt-4">Encomendas</h5>
                <ul class="list-unstyled mt-3">
                    <li><a href="/account/history" class="text-decoration-none text-muted">Histórico</a></li>
                    <li><a href="/account/stats" class="text-decoration-none text-muted">Estatísticas de Gastos</a></li>
                    <li><a href="/account/tracking" class="text-decoration-none text-muted">Tracking de Preços</a></li>
                </ul>
                <h5 class="fw-bold mt-4">Outros</h5>
                <ul class="list-unstyled mt-3">
                    <li><a href="/account/notifications" class="text-decoration-none text-muted">Notificações</a></li>
                    <li><a href="/account/points" class="text-decoration-none text-muted">Pontos</a></li>
                    <li><a href="/account/settings" class="text-decoration-none text-orange">Definições</a></li>
                </ul>
            </div>
        </div>

        <!-- Formulário de Definições da Conta -->
        <div class="col-md-9 d-flex align-items-center">
            <div class="p-4 border rounded shadow-sm w-100 align-self-center">
                <h4 class="fw-bold text-orange">Definições da Conta</h4>
                <form id="settingsForm">
                    <div class="row g-3">
                        <!-- Ativar 2 fatores -->
                        <h5 class="fw-bold mt-4">Segurança</h5>
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Autenticação de Dois Fatores (2FA)</label>
                            <select class="form-select" name="2faMethod">
                                <option value="none" selected>Desativado</option>
                                <option value="email">Código via E-mail</option>
                            </select>
                        </div>

                        <!-- Botões -->
                        <div class="col-12 d-flex justify-content-between mt-3">
                            <button type="reset" class="btn btn-outline-secondary">Cancelar</button>
                            <button type="submit" class="btn btn-primary" id="saveSettingsBtn">Guardar Alterações
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>
</section>

<!-- Footer -->
<%@ include file="includes/footer.jsp" %>

</body>
</html>