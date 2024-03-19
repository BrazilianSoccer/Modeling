data {
    int<lower=1> num_jogos;  // Número total de jogos
    int<lower=1> num_equipes;  // Número total de equipes
    array[num_jogos] int<lower=1, upper=num_equipes> equipe1;  // Equipe 1 em cada jogo
    array[num_jogos] int<lower=1, upper=num_equipes> equipe2;  // Equipe 2 em cada jogo
    array[num_jogos] int<lower=0, upper=1> vitoria_equipe1;  // 1 se equipe1 venceu, 0 caso contrário
}

parameters {
    real home_force;
    vector[num_equipes] habilidade;  // Habilidade de cada equipe
}

model {
    habilidade ~ normal(0, 1);  // Prior normal para as habilidades
    home_force ~ normal(0, 1);  // Prior normal para a força do mandante
    for (jogo in 1:num_jogos) {
        // Likelihood do modelo Bradley-Terry
        if (vitoria_equipe1[jogo] == 1) {
            target += log(exp(habilidade[equipe1[jogo]] + home_force)) - log(exp(habilidade[equipe1[jogo]] + home_force) + exp(habilidade[equipe2[jogo]]));
        } else {
            target += habilidade[equipe2[jogo]] - log(exp(habilidade[equipe1[jogo]] + home_force) + exp(habilidade[equipe2[jogo]]));
        }
    }
}